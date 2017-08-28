//
//  $file_name
//  $project_name
//
//  Created by Akhilraj on $date.
//  Copyright © 2017 Akhilraj. All rights reserved.
//

import Foundation
import ObjectMapper

class $class_name : BaseWebService {

    typealias successCallback = ($response_var: $response_type?) -> Void
    typealias failureCallback = (error: NSError) -> Void

    var success:successCallback?
    var failure:failureCallback?

    func $method_name($request_var onSuccess:successCallback, onFailure:failureCallback) {

        self.success = onSuccess
        self.failure = onFailure
        self.urlString = "$endpoint"
        self.requestMethod = $request_type
        self.parameters = $request_params
        self.startWebService({ JSON in

            let response = Mapper<$response_model>().$map_type(JSON)
            self.success?($response_var: response)
            }) { error in

                self.failure?(error: error!)
        }
    }
}
