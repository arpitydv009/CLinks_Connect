//
//  discussionModel.swift
//  CLinks_Connect
//
//  Created by arpit on 08/10/26.
//


struct discussionModel: Identifiable {
    let id: Int
    let title: String
    var replies: [replyModel]
    let timestamp: String
    let author: String

}

