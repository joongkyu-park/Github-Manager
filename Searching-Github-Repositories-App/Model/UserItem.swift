import Foundation

struct UserItem: Decodable {
    let login, name, bio, avatarUrl: String
    let followers, following: Int

    enum CodingKeys: String, CodingKey {
        case login, name, bio, followers, following
        case avatarUrl = "avatar_url"
    }
}
