import Foundation
import ParseSwift

struct PokemonFavoriteEntry: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var pokemonID: Int?
    var user: User?
}
