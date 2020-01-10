import Foundation
import UIKit

class BaseElement: Codable {
    
    var image :UIImage?
    var loves :Bool?
    var text:(Bool,String)? // сделать просто String
    
    private enum CodingKeys: String, CodingKey { // набор ключей под которыми будут упаковываться проперти
        case image
        case loves
    }
    
    init() {}

    required init(from decoder: Decoder) throws { //обязательная инициализация //процедура сборки объекта из даты
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: data)
        loves = try container.decode(Bool.self, forKey: .loves)
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let photo = image {
            guard let data = photo.jpegData(compressionQuality: 1) else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
            try container.encode(self.loves, forKey: CodingKeys.loves)
        }
    }
}
