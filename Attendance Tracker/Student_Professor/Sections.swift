//
//  Sections.swift
//  Student_Professor
//
//  Created by Malgireddy,Prashanth Reddy on 4/13/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class Sections:NSObject {
    
    var entityId:String?
    var crn:String?
    var metadata:KCSMetadata?
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "crn" : "Crn",
            "metadata" : KCSEntityKeyMetadata
        ]
    }

}