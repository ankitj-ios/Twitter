//
//  TwitterUtils.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/1/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class TwitterUtils: NSObject {
    
    class func getStringFromDate(date : NSDate) -> String {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateformatter.stringFromDate(date)
    }

}
