// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Decodable { // TODO: try to remove unrequired structs
    let response: Response
}

// MARK: - Response
struct Response: Decodable {
    let items: [Item]
    let profiles: [Profile]
    let groups: [Group]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

// MARK: - Group
struct Group: Decodable, ProfileInterface {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let photo50, photo100, photo200: String
    
    var photo: String { return photo100 }

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

// MARK: - Item
struct Item: Decodable { // 3. Создать класс для представления новости типа post.
    let sourceID, date: Int?
    let text: String?
    let markedAsAds: Int?
    let attachments: [Attachment?]?
    let comments: Comments?
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    let postID: Int?
    let topicID: Int?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case comments, likes, reposts, views
        case postID = "post_id"
        case topicID = "topic_id"
    }
}

// MARK: - Attachment
struct Attachment: Decodable {
    let type: String
    let photo: AttachmentPhoto?
    let link: Link?
    let video: Video?
    
    var postPhoto: String?
    {
        switch type {
        case "photo":
            return photo?.photo604
        case "link":
            return link?.photo?.photo604
        case "video":
            return video?.photo800
        default:
            return nil
        }
}
}

// MARK: - AttachmentPhoto
struct AttachmentPhoto: Decodable { // 5. *Создать класс для представления новости типа photo.
    let albumID, date, id, ownerID: Int?
    let hasTags: Bool?
    let accessKey: String?
    let height: Int?
    let photo1280, photo130: String?
    let photo2560: String?
    let photo604, photo75, photo807: String?
    let postID: Int?
    let text: String?
    let userID, width: Int?
    
    var postPhoto: String { return photo604!}

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case height
        case photo1280 = "photo_1280"
        case photo130 = "photo_130"
        case photo2560 = "photo_2560"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case photo807 = "photo_807"
        case postID = "post_id"
        case text
        case userID = "user_id"
        case width
    }
}

// MARK: - Video
struct Video: Decodable {
    let accessKey: String?
    let canComment, canLike, canRepost, canSubscribe: Int?
    let canAddToFaves, canAdd, date: Int?
    let videoDescription: String?
    let duration: Int?
    let photo130, photo320, photo800, photo1280: String?
    let firstFrame130, firstFrame160, firstFrame320, firstFrame800: String?
    let firstFrame1280: String?
    let width, height, id, ownerID: Int?
    let title, trackCode: String?
    let videoRepeat: Int?
    let views: Int?
    let comments: Int?
    
    var postPhoto: String { return photo800!}

    enum CodingKeys: String, CodingKey {
        case accessKey = "access_key"
        case canComment = "can_comment"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAdd = "can_add"
        case date
        case videoDescription = "description"
        case duration
        case photo130 = "photo_130"
        case photo320 = "photo_320"
        case photo800 = "photo_800"
        case photo1280 = "photo_1280"
        case firstFrame130 = "first_frame_130"
        case firstFrame160 = "first_frame_160"
        case firstFrame320 = "first_frame_320"
        case firstFrame800 = "first_frame_800"
        case firstFrame1280 = "first_frame_1280"
        case width, height, id
        case ownerID = "owner_id"
        case title
        case trackCode = "track_code"
        case videoRepeat = "repeat"
        case views, comments
    }
}

// MARK: - Link
struct Link: Decodable {
    let url: String?
    let title, linkDescription: String?
    let target: String?
    let photo: LinkPhoto?
    let caption: String?

    enum CodingKeys: String, CodingKey {
        case url, title
        case linkDescription = "description"
        case target, photo, caption
    }
}

// MARK: - LinkPhoto
struct LinkPhoto: Decodable {
    let albumID, date, id, ownerID: Int?
    let hasTags: Bool?
    let height: Int?
    let photo130, photo604, photo75: String?
    let text: String?
    let userID: Int?
    let width: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case height
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case text
        case userID = "user_id"
        case width
    }
}


// MARK: - Comments
struct Comments: Decodable {
    let count, canPost: Int
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

// MARK: - Likes
struct Likes: Decodable {
    let count, userLikes, canLike, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

// MARK: - Reposts
struct Reposts: Decodable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Decodable {
    let count: Int
}

// MARK: - Profile
struct Profile: Decodable, ProfileInterface {
    let id: Int
    let firstName, lastName: String
    let sex: Int
    let screenName: String?
    let photo50, photo100: String
    let online: Int
    let onlineInfo: OnlineInfo
    let deactivated: String?
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineInfo = "online_info"
        case deactivated
    }
}

// MARK: - OnlineInfo
struct OnlineInfo: Decodable {
    let visible, isOnline, isMobile: Bool!
    let lastSeen: Int?

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
        case lastSeen = "last_seen"
    }
}

protocol ProfileInterface {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}
