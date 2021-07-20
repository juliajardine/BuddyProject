import Foundation
import UIKit

@objc
protocol ImageDownloadable {
    func download(with url: URL, completion: @escaping (UIImage?) -> Void)
    func cancel()
}

@objc
class ImageDownloader: NSObject, ImageDownloadable {
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func download(with url: URL, completion: @escaping (UIImage?) -> Void) {
        dataTask = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            completion(image)
        }
        
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
}

@objc
extension UIImageView {
    private enum AssociatedType {
        static var downloader = "downloader"
    }
    
    private var imageDownloader: ImageDownloadable? {
        get {
            objc_getAssociatedObject(self, &AssociatedType.downloader) as? ImageDownloadable
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedType.downloader, newValue as ImageDownloadable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func setImage(with url: String) {
        if imageDownloader == nil {
            imageDownloader = ImageDownloader()
        }
        
        cancel()
        
        guard let url = URL(string: url) else { return }
        
        imageDownloader?.download(with: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    func cancel() {
        self.image = nil
        
        imageDownloader?.cancel()
    }
}
