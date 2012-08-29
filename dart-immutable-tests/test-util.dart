// Copyright 2012 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: Paul Brauner (polux@google.com)

/**
 * A datatype with an imperfect hash function
 */
class Key implements Hashable {
  int i;
  bool b;
  Key(this.i, this.b);
  bool operator ==(Key other) {
    if (other is! Key) return false;
    return i == other.i && b == other.b;
  }
  int hashCode() => i.hashCode();
  toString() => "Key($i,$b)";
}

/**
 * Enumerations of [Key] and [ModelMap].
 */
class Enumerations {
  Combinators c;
  Enumeration<Key> keys;
  Enumeration<Map<Key, int>> maps;
  Enumeration<ModelMap<Key, int>> modelMaps;

  Enumerations() {
    c = new Combinators();
    keys = singleton((i) => (b) => new Key(i, b)).apply(c.ints).apply(c.bools);
    maps = c.mapsOf(keys, c.ints);
  }
}

ImmutableMap implemFrom(Map m) => new ImmutableMap.fromMap(m);
ModelMap modelFrom(Map m) => new ModelMap(m);

class _Stop implements Exception {}

bool same(ImmutableMap im, ModelMap mm) {
  final Map m1 = im.toMap();
  final Map m2 = mm.map;
  if (m1.length != m2.length) return false;
  try {
    m1.forEach((k, v) {
      if (!m2.containsKey(k)) throw new _Stop();
      if (v != m2[k]) throw new _Stop();
    });
  } catch (_Stop e) {
    return false;
  }
  return true;
}