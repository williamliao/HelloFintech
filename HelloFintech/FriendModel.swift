//
//  FriendModel.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import Foundation

enum FriendStatus:Int, Codable, Equatable {
    case invited
    case finished
    case inviting
}

struct FriendModelRespone: Codable {
    var response: [FriendModel]
}

struct FriendModel: Codable, Equatable, Hashable {
    let name: String
    let isTop: String
    let fid: String
    let updateDate: String
    let status: FriendStatus
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(fid)
    }
 
    static func == (lhs: FriendModel, rhs: FriendModel) -> Bool {
        return lhs.fid == rhs.fid && lhs.updateDate == rhs.updateDate
    }
}
