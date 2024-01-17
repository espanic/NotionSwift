//
//  Created by Wojciech Chojnacki on 17/04/2022.
//

import Foundation
import Tagged

public struct PartialUser : Equatable, Sendable {
    public let id: User.Identifier
    
    public init(id: User.Identifier) {
        self.id = id
    }
}

extension PartialUser: Codable {}

@available(iOS 13.0, *)
extension PartialUser: Identifiable {}

