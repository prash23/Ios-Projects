//
//  PresentStudents.swift
//  Student_Professor
//
//  Created by Gutta,Hima Teja on 4/17/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class PresentStudents:NSObject
{
    var entityId:String?
    var faculty_ID:String?
    var presentStudents:[String]?
    var section_ID:String?
     var date:String?
    var metadata:KCSMetadata?
    
  override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "faculty_ID" : "faculty_ID",
            "presentStudents" : "present_students",
            "section_ID" : "section_ID",
            "date" : "date",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
    
}
