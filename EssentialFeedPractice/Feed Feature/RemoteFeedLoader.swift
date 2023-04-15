//
//  RemoteFeedLoader.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidCode
    }
    
    public typealias FeedLoaderResult = Result<[FeedItem], Error>
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (FeedLoaderResult) -> ()) {
        // Default closure to make sure tests that don't test error case don't break
        client.get(from: url) { [weak self] result in
            switch result {
            case .success((let data, let response)):
                if let mappedFeedItems = try? FeedItemsMapper.map(data: data, response: response) {
                    completion(.success(mappedFeedItems))
                } else {
                    completion(.failure(.invalidCode))
                }
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
}

private class FeedItemsMapper {
    private struct RootNode: Decodable {
        let items: [APIFeedItem]
    }

    private struct APIFeedItem: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    static var OK_200Response: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard let rootNode_fromDecodedJSON = try? JSONDecoder().decode(RootNode.self, from: data), response.statusCode == OK_200Response else {
            throw RemoteFeedLoader.Error.invalidCode
        }
        return rootNode_fromDecodedJSON.items.map { $0.item }
    }
}
