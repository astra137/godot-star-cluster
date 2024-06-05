use godot::prelude::*;

use crate::cosmic::FromFixed3;

mod database;

#[derive(GodotClass)]
#[class(init)]
pub struct CosmicDatabase {
	inner: database::Database,
}

#[godot_api]
impl CosmicDatabase {
	#[func]
	fn size(&self) -> i64 {
		self.inner.len().try_into().unwrap_or(-1)
	}

	#[func]
	fn insert(&mut self, x: i64, y: i64, z: i64) -> i64 {
		self.inner.insert([x, y, z])
	}

	#[func]
	fn remove(&mut self, k: i64) {
		self.inner.remove(k)
	}

	#[func]
	fn schooch(&mut self, k: i64, delta: Vector3) {
		self.inner.schooch(k, [delta.x, delta.y, delta.z])
	}

	#[func]
	fn absolute(&self, k: i64) -> PackedInt64Array {
		PackedInt64Array::from(self.inner.absolute(k))
	}

	#[func]
	fn relative(&self, k: i64, x: i64, y: i64, z: i64) -> Vector3 {
		let [x, y, z] = self.inner.relative(k, x, y, z).to_num();
		Vector3::new(x, y, z)
	}

	#[func]
	fn nearby(&mut self, x: i64, y: i64, z: i64) -> PackedInt64Array {
		PackedInt64Array::from(self.inner.nearby([x, y, z]).as_slice())
	}

	#[func]
	fn nearest(&mut self, x: i64, y: i64, z: i64) -> i64 {
		self.inner.nearest([x, y, z])
	}
}
