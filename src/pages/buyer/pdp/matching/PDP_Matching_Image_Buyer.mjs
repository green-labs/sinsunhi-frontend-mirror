// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ImageWithPlaceholder from "../../../../components/common/ImageWithPlaceholder.mjs";

function PDP_Matching_Image_Buyer(Props) {
  var src = Props.src;
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("div", {
                  className: "relative overflow-hidden"
                }, React.createElement(ImageWithPlaceholder.make, {
                      src: src,
                      placeholder: ImageWithPlaceholder.Placeholder.lg,
                      className: "w-full max-h-[300px] object-contain",
                      alt: "product-detail-thumbnail"
                    }), React.createElement("div", {
                      className: "w-full h-full absolute top-0 left-0 bg-black/[.03]"
                    })));
}

var make = PDP_Matching_Image_Buyer;

export {
  make ,
}
/* react Not a pure module */
