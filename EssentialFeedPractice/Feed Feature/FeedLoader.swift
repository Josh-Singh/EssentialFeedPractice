//
//  FeedLoader.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

protocol FeedLoader {
    func load(completion: @escaping (Result<[FeedItem], Error>) -> ())
}
