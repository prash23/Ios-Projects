//
//  Students.swift
//  Student_Professor
//
//  Created by Somu,Vinod Reddy on 4/6/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class Students: NSObject
{
    var entityId: String?
    var Student_ID:String?
    var FirstName:String?
    var LastName:String?
    var Password:String?
    var sections:[String]?
    var metadata: KCSMetadata?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "Student_ID" : "Student_ID",
            "FirstName" : "FirstName",
            "LastName" : "LastName",
            "Password" : "Password",
            "sections" : "sections",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
}
