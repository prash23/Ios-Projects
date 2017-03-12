//
//  stuAttendance.swift
//  Student_Professor
//
//  Created by Somu,Vinod Reddy on 4/16/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class stuAttendance: NSObject
{
    var entityId: String?
    var student_ID:String?
    var section:String?
    var password:String?
    var metadata:KCSMetadata?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]!
    {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "student_ID" : "student_ID",
            "section" : "section",
            "password" : "password",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]

    }

}
