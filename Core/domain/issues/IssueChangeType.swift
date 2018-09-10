//
//  IssueChangeType.swift
//  Core
//
//  Created by Carlos Chaguendo on 7/09/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper


public class UserChange: BasicEntity {

    @objc public dynamic var id: String = "-1-"
    @objc public dynamic var value: User?
    @objc public dynamic var previus: User?

    public override static func primaryKey() -> String? {
        return "id"
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["new"]
        previus <- map["old"]
    }
}


public class StringChange: BasicEntity {

    @objc public dynamic var id: String = "-1-"
    @objc public dynamic var value: String?
    @objc public dynamic var previus: String?

    public override static func primaryKey() -> String? {
        return "id"
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["new"]
        previus <- map["old"]
    }
}




public class IssueChanges: BasicEntity {
    
    @objc public dynamic var id: String = "-1-" {
        willSet{
            setIdToChangesItems(id: newValue)
        }
    }
    @objc public dynamic var state: StringChange?
    @objc public dynamic var assignee: StringChange?
    @objc public dynamic var responsible: StringChange?
    @objc public dynamic var priority: StringChange?
    @objc public dynamic var kind: StringChange?
    @objc public dynamic var version: StringChange?
    @objc public dynamic var component: StringChange?
    @objc public dynamic var content: StringChange?
    @objc public dynamic var attachment: StringChange?
    @objc public dynamic var title: StringChange?
    @objc public dynamic var milestone: StringChange?
    
    @objc private dynamic var _html: String?
    

    public override static func primaryKey() -> String? {
        return "id"
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        state <- map["state"]
        assignee <- map["assignee"]
        responsible <- map["responsible"]
        priority <- map["priority"]
        kind <- map["kind"]
        version <- map["version"]
        component <- map["component"]
        content <- map["content"]
        attachment <- map["attachment"]
        title <- map["title"]
        milestone <- map["milestone"]
    }
    
    public func setIdToChangesItems(id: String) {
        state?.id = "\(id)-state"
        assignee?.id = "\(id)-assignee"
        responsible?.id = "\(id)-responsible"
        priority?.id = "\(id)-priority"
        kind?.id = "\(id)-kind"
        version?.id = "\(id)-version"
        component?.id = "\(id)-component"
        content?.id = "\(id)-content"
        attachment?.id = "\(id)-attachment"
        title?.id = "\(id)-title"
        milestone?.id = "\(id)-milestone"
    }
    
    public var html: String {
        
        if let _html = self._html, _html.isEmpty == false {
            return _html
        }
        
        let html = NSMutableString()
        
        if let state = self.state {
            html.append("<li>∙ Status changed to \(state.value.orEmpty)</li>\n")
        }
        
        if let assignee = self.assignee {
            html.append("<li>∙ Incidence assigned to @\(assignee.value.orEmpty)</li>\n")
        }
        
        if let responsible = self.responsible {
            html.append("<li>∙ Responsible assigned to @\(responsible.value.orEmpty)</li>\n")
        }
        
        if let _ = self.content {
            html.append("<li>∙ Edited description</li>\n")
        }
        
        if let attachment = self.attachment {
            html.append("<li>∙ Attachment \(attachment.value.orEmpty)</li>\n")
        }
        
        if let title = self.title {
            html.append("<li>∙ Title changed to \(title.value.orEmpty)</li>\n")
        }
        
        if let priority = self.priority {
            html.append("<li>∙ Marked as  \(priority.value.orEmpty)</li>\n")
        }
        
        if let kind = self.kind {
            html.append("<li>∙ Marked as  \(kind.value.orEmpty)</li>\n")
        }
        
        if let version = self.version {
            html.append("<li>∙ Version changed to \(version.value.orEmpty)</li>\n")
        }
        
        if let component = self.component {
            html.append("<li>∙ Component changed to \(component.value.orEmpty)</li>\n")
        }
        
        if let milestone = self.milestone {
            html.append("<li>∙ Milestone changed to \(milestone.value.orEmpty)</li>\n")
        }
        
        self._html = html.description
        return self._html!
    }
}
