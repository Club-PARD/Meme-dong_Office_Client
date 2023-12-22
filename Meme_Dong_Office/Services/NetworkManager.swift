import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: completion)
        task.resume()
    }
}
