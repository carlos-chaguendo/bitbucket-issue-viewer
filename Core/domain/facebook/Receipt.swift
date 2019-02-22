//
//  Receipt.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class Payload: BasicEntity {
    @objc public dynamic var template_type: String = "receipt"
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        template_type <- map["template_type"]
    }
}

public class Receipt: Payload {

    /// Nombre del destinatario
    @objc public dynamic var name: String?

    /// Numero de factura
    @objc public dynamic var number: String?

    /// Moneda
    @objc public dynamic var currency: String = "COP"

    /// Metodo de pago `Visa 2345`
    @objc public dynamic var paymentMethod: String?

    /// URL web del pedido
    @objc public dynamic var orderUrl: String?

    /// Hora de compra
    @objc public dynamic var timestamp: Int = 0

    /// Direccion de envio del pedido
    @objc public dynamic var address: RecipientAddress?

    /// Resumen del pedido
    @objc public dynamic var summary: RecipientSummary?

    /// ELementos que se envian
    public var elements = List<RecipientElement>()

    required convenience public init(_ map: Map) {
        self.init()
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["recipient_name"]
        number <- map["order_number"]
        currency <- map["currency"]
        paymentMethod <- map["payment_method"]
        orderUrl <- map["order_url"]
        timestamp <- map["timestamp"]
        address <- map["address"]
        summary <- map["summary"]
        elements <- (map["elements"], ArrayTransform<RecipientElement>())
    }

}
