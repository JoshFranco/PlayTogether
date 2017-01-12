//
//  GameObj.swift
//  PlayTogether
//
//  Created by mac on 1/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import Firebase

struct GameObj {

    //Firebase refreance and key for pulling and pushing to the database
    let key: String
    let ref: FIRDatabaseReference?
    
    //Game data we will be pulling and pushing
    let addedByUser: String //the email of the user (unique)
    let userName: String // user name (NOT unique)
    let game: String // game title
    let store: String //store location
    let time: String //time of game
    let playerNum: Int
    
    
    init(userName: String, game: String, store: String, time: String, addedByUser: String, key: String = "", playerNum: Int = 0) {
        self.key = key
        
        //The game data
        self.userName = userName
        self.game = game
        self.store = store
        self.time = time
        self.addedByUser = addedByUser
        self.playerNum = playerNum
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        userName = snapshotValue["userName"] as! String
        game = snapshotValue["game"] as! String
        store = snapshotValue["store"] as! String
        time = snapshotValue["time"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        
        playerNum = snapshotValue["playerNum"] as? Int ?? 0
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "game": game,
            "store": store,
            "time": time,
            "addedByUser": addedByUser,
            "playerNum": playerNum
        ]
    }
}
