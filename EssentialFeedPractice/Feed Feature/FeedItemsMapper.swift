//
//  FeedItemsMapper.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/19/23.
//

import Foundation

class FeedItemsMapper {
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
    
    private static var OK_200Response: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard let rootNode_fromDecodedJSON = try? JSONDecoder().decode(RootNode.self, from: data), response.statusCode == OK_200Response else {
            throw RemoteFeedLoader.Error.invalidCode
        }
        return rootNode_fromDecodedJSON.items.map { $0.item }
    }
}
