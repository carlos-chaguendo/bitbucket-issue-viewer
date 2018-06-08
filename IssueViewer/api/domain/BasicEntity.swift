
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class BasicEntity: Object, Mappable {

	public required init(map: Map) {
		super.init()
	}

	required public init() {
		super.init()
	}

	required public init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}

	required public init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}

	public override init(value: Any) {
		super.init(value: value)
	}

	public func mapping(map: Map) {

	}



}






public extension BasicEntity {
    
    public func detached() -> Self {
        return type(of: self).init(value:self,schema: RLMSchema.partialShared())
    }
    
}


public extension Sequence  where Iterator.Element:BasicEntity  {
    
    public var detached:[Element] {
        return self.map({ $0.detached() })
    }
    
}


