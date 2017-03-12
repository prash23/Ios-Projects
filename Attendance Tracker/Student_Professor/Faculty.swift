//
//  Faculty.swift
//  Student_Professor
//
//  Created by Abhinesh on 4/7/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class Faculty: NSObject
{
    var entityId:String?
    var Faculty_ID:String?
    var FirstName:String?
    var LastName:String?
    var Password:String?
    var Section:[String]?
    var metadata:KCSMetadata?
    
    
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "Faculty_ID" : "Faculty_ID",
            "FirstName" : "FirstName",
            "LastName" : "LastName",
            "Password" : "Password",
            "Section":"Section",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }

}
