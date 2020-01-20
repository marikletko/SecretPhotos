import Foundation
import UIKit

class ImageProperties: Codable {
    var loves :Bool?
    var text: String?
    var textPos:CGPoint?
    
    private enum CodingKeys: String, CodingKey {
        case loves
        case text
        case textPos
    }
    
    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        loves = try container.decodeIfPresent(Bool.self, forKey: .loves)
        textPos = try container.decodeIfPresent(CGPoint.self, forKey: .textPos)
    }
    

}
