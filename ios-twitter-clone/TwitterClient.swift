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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())? // we have to store this for some reason

    class var sharedInstance: TwitterClient { // this is sorta like a class so you don't have to declare the consumer key/secret more than once
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: params,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
//                for tweet in tweets {
//                    println("text: \(tweet.text), createdAt: \(tweet.createdAt)")
//                }
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get home timeline")
                completion(tweets: nil, error: nil)
        })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token; redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "hammy://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                println("got request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }
            ) {(error: NSError!) -> Void in
                println("failed to get request token")
                self.loginCompletion?(user: nil, error: error) // no one logged in
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                println("got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        var user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        println("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("failed to get user")
                        self.loginCompletion?(user: nil, error: error) // no one logged in
                })
                            }) {(error: NSError!) -> Void in
                println("error getting access token")
                self.loginCompletion?(user: nil, error: error) // no one logged in
        }

    }
}
