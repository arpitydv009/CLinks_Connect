//
//  postModel.swift
//  CLinks_Connect
//
//  Created by arpit on 08/10/26.
//

import Foundation


struct postModel: Identifiable {
    let id: Int
    let author: String
    let content: String
    let timestamp: String
    var likes: Int
    let comments: Int
    let commentsList: [commentModel]
    let imageName: String?
    let databaseID: UUID?
    let imageURL: String?


}
