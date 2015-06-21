/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule createReactNativeComponentClass
 * @flow
 */

'use strict';

var ReactNativeBaseComponent = require('ReactNativeBaseComponent');

// See also ReactNativeBaseComponent
type ReactNativeBaseComponentViewConfig = {
  validAttributes: Object;
  uiViewClassName: string;
}

/**
 * @param {string} config iOS View configuration.
 * @private
 */
var createReactNativeComponentClass = function(
  viewConfig: ReactNativeBaseComponentViewConfig
): ReactClass<any, any, any> {
  var Constructor = function(element) {
    this._currentElement = element;

    this._rootNodeID = null;
    this._renderedChildren = null;
    this.previousFlattenedStyle = null;
  };
  Constructor.displayName = viewConfig.uiViewClassName;
  Constructor.viewConfig = viewConfig;
  Constructor.prototype = new ReactNativeBaseComponent(viewConfig);
  Constructor.prototype.constructor = Constructor;

  // bparadie, 2015-06-21: Rolling back changes introduced by 1acca01:
  // [Flow] Fix or suppress react-native github errors for Flow v0.12.0.
  // return ((Constructor: any): ReactClass);
  return Constructor;
};

module.exports = createReactNativeComponentClass;
