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

        if map.mappingType == ObjectMapper.MappingType.toJSON {
            if self.realm != nil {
                let error = "[\(type(of: self))] is Managed by realm, detach before convert to json"
                Logger.error(error)
                preconditionFailure(error)
            }
        }

    }
}
