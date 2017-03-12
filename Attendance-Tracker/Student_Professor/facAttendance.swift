//
//  facAttendance.swift
//  Student_Professor
//
//  Created by Somu,Vinod Reddy on 4/16/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class facAttendance: NSObject
{
    var entityId: String?
    var faculty_ID:String?
    var facCrn:String?
    var password:String?
    var metadata:KCSMetadata?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]!
    {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "faculty_ID" : "faculty_ID",
            "facCrn" : "facCrn",
            "password" : "password",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
        
    }

}
