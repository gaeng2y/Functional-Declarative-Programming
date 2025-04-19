import Foundation

public actor FileIOManager {
    public static let shared = FileManager()
    private init() { }
    
    private lazy var memCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 100_000_000
        return cache
    }()
}

// MARK: - define errors
public extension FileIOManager {
    enum ErrorType: Error {
        case noData
        case noFilePath
        case fileNotFound
    }
}

// MARK: - define types
public extension FileIOManager {
    
    enum DataLocationType {
        case cache
        case document
        
        public var directoryPath: String? {
            switch self {
            case .cache:
                return NSSearchPathForDirectoriesInDomains(
                    .cachesDirectory,
                    .allDomainsMask, true
                ).first
            case .document:
                return NSSearchPathForDirectoriesInDomains(
                    .documentDirectory,
                    .allDomainsMask, true
                ).first
            }
        }
    }
    
    enum DataStorageType {
        case cache(data: Data)
        case document(data: Data)
        
        public var directoryPath: String? {
            self.locationType.directoryPath
        }
        
        public var data: Data {
            switch self {
            case .cache(let data), .document(let data):
                return data
            }
        }
        
        private var locationType: DataLocationType {
            switch self {
            case .cache:
                return .cache
            case .document:
                return .document
            }
        }
    }
}

// MARK: - accessing cache
public extension FileIOManager {
    func loadObject(object: DataLocationType, forKey key: String) -> Result<Data, Error> {
        let cacheKey = NSString(string: key)
        if let cachedData = self.memCache.object(forKey: cacheKey) as? Data {
            return .success(cachedData)
        }
        
        guard let directoryPath = object.directoryPath else {
            return .failure(ErrorType.noFilePath)
        }
        
        return self.loadFile(from: directoryPath, forKey: key)
    }
    
    
    func saveObject(object: DataStorageType, forKey key: String) {
        let cacheKey = NSString(string: key)
        let cacheData = NSData(data: object.data)
        self.memCache.setObject(cacheData, forKey: cacheKey)
        
        guard let directoryPath = object.directoryPath else {
            return
        }
        
        Task {
            await self.saveFile(data: object.data, to: directoryPath, forKey: key)
        }
    }
}

// MARK: - file I/O
extension FileIOManager {
    private func loadFile(from directoryPath: String, forKey fileName: String) -> Result<Data, Error> {
        var data: Data?
        let directoryURL = URL(filePath: directoryPath)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        data = try? Data(contentsOf: fileURL)
        
        if let data = data {
            return .success(data)
        } else {
            return .failure(ErrorType.fileNotFound)
        }
    }
    
    private func saveFile(data: Data, to directoryPath: String, forKey fileName: String) async {
        let directoryURL = URL(filePath: directoryPath)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do {
            if !self.checkDirectory(directoryPath: directoryURL.absoluteString) {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - utility
extension FileIOManager {
    private func checkDirectory(directoryPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
            || isDirectory.boolValue == false {
            return false
        }
        
        return true
    }
}
