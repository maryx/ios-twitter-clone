//
//  TwitterClient.swift
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/27/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

let twitterConsumerKey = "yJ4FZlwxIy2nZ46yQZUXuMU9K"
let twitterConsumerSecret = "oOl638YG0Ceo4VRHtkAZ41sM3H5uEXEM6cCC6bbUQKepCZNCVL"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    class var sharedInstance: TwitterClient { // this is sorta like a class so you don't have to declare the consumer key/secret more than once
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
