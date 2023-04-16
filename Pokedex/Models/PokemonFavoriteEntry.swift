import Foundation
import ParseSwift

struct PokemonFavoriteEntry: ParseObject, Equatable {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var pokemonID: Int?
    var user: User?
    
    static func == (lhs: PokemonFavoriteEntry, rhs: PokemonFavoriteEntry) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}
