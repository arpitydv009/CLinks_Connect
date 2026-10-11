//
//  SupabaseManager.swift
//  CLinks_Connect
//
//  Created by arpit on 10/10/26.
//

import Supabase
import Foundation

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client = SupabaseClient(
        supabaseURL: URL(string:"https://nyrfrlzkrwedttdztbmp.supabase.co")!, supabaseKey: "sb_publishable_F8XNS646jnKGRMd_SZPDFQ_JSBWBzuo"
    
    )
    
    
}
