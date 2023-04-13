import Foundation

struct RepositoryDataItem: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryItem]

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}

typealias RepositoryItems = [RepositoryItem]

struct RepositoryItem: Decodable {
    let name, visibility, fullName, updatedAt: String
    let description, language: String?
    let id, openIssuesCount, forksCount, stargazersCount: Int
    let topics: [String]
    let license: License?
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case name, id, description, topics, language, visibility, license, owner
        case fullName = "full_name"
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case updatedAt = "updated_at"
        case openIssuesCount = "open_issues_count"
    }
}

struct License: Decodable {
    let name: String
}

struct Owner: Decodable {
    let login: String
}
