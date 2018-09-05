//
//  IAPService.swift
//  Gifty
//
//  Created by Tim Beals on 2018-08-24.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import StoreKit

class IAPService : NSObject { //NSObject required to interact with ObjC on the backend
    
    //MARK: Public Properties
    static let shared = IAPService()
    
    //MARK: Private Properties
    private override init() {    }
    
    private var products = [SKProduct]()
    
    private var paymentQueue = SKPaymentQueue.default()
    
    var fullVersionPrice: Float?
}

//MARK: Public API
extension IAPService {
    
    func getProducts() {
        
        let products: Set = [SKProduct.product.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchaseProduct(_ product: SKProduct.product) throws {
        
        guard let prod = getProductFromArray(product) else {
            throw IAPError.productNotReceived
        }
        
        let payment = SKPayment(product: prod)
        paymentQueue.add(payment)
        
    }
    
    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
}

//MARK: Private Interface
extension IAPService {
    
    private enum IAPError: Error {
        case productNotReceived
    }
    
    private func getProductFromArray(_ product: SKProduct.product) -> SKProduct? {
        guard let prod = products.filter({ $0.productIdentifier == product.rawValue }).first else {
            return nil
        }
        return prod
    }
    
}

//MARK: SKProductsRequestDelegate
extension IAPService : SKProductsRequestDelegate {
    
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.isEmpty {
            print("IAPService: line \(#line): No products received in response")
        }
        
        for product in response.products {
            self.fullVersionPrice = Float(truncating: product.price)
        }
        self.products = response.products
    }
}

//MARK: SKPaymentTransactionObserver (delegate)
extension IAPService: SKPaymentTransactionObserver {
    
    internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            print(transaction.transactionState.status(), "For product: \(transaction.payment.productIdentifier)")
            
            if let error = transaction.error {
                print(error.localizedDescription)
            }
            
            //Cleans the transaction queue so user can repurchase consumable content.
            switch transaction.transactionState {
            case .purchasing: break
            case .purchased:
                SettingsHandler.shared.showInterstitials = false
                queue.finishTransaction(transaction)
            case .failed, .restored:
                InterstitialService.shared.isSuspended = false
                queue.finishTransaction(transaction)
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
}
