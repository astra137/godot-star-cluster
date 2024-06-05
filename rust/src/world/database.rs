use fixed::traits::ToFixed;

use crate::cosmic::{Cosmic3, FromFixed3};
use std::collections::HashMap;

#[derive(Default)]
pub struct Database {
	points_course: HashMap<i64, [i64; 3]>,
	points_fine: HashMap<i64, Cosmic3>,
	highest: i64,
	available: Vec<i64>,
}

impl Database {
	pub fn len(&self) -> usize {
		self.points_course.len()
	}

	pub fn insert(&mut self, position: [i64; 3]) -> i64 {
		let k: i64 = match self.available.pop() {
			Some(k) => k,
			None => {
				self.highest += 1;
				self.highest - 1
			}
		};
		self.points_course.insert(k, position);
		self.points_fine.insert(k, Cosmic3::default() + position);
		k
	}

	pub fn remove(&mut self, k: i64) {
		self.points_course.remove(&k);
		self.points_fine.remove(&k);
		self.available.push(k);
	}

	pub fn schooch<T>(&mut self, k: i64, delta: [T; 3])
	where
		T: ToFixed + Copy,
	{
		let course = self.points_course.get_mut(&k).unwrap();
		let fine = self.points_fine.get_mut(&k).unwrap();
		*fine += delta;
		*course = fine.to_num();
	}

	pub fn absolute(&self, k: i64) -> &[i64; 3] {
		self.points_course.get(&k).unwrap()
	}

	pub fn relative(&self, k: i64, x: i64, y: i64, z: i64) -> Cosmic3 {
		let from = Cosmic3::default() + [x, y, z];
		let fine = self.points_fine.get(&k).unwrap();
		*fine - from
	}

	pub fn nearby(&self, position: [i64; 3]) -> Vec<i64> {
		let mut results = Vec::new();
		for (k, v) in &self.points_course {
			let point_distance_sq = distance_sq_f64(v, &position);
			if point_distance_sq < 2.2376357e33 {
				results.push(*k)
			}
		}
		results
	}

	pub fn nearest(&self, position: [i64; 3]) -> i64 {
		let mut result = -1;
		let mut best_distance_sq = f64::INFINITY;
		for (k, v) in &self.points_course {
			let point_distance_sq = distance_sq_f64(v, &position);
			if point_distance_sq < best_distance_sq {
				best_distance_sq = point_distance_sq;
				result = *k;
			}
		}
		result
	}
}

fn distance_sq_f64([x1, y1, z1]: &[i64; 3], [x2, y2, z2]: &[i64; 3]) -> f64 {
	let x = (x1 - x2) as f64;
	let y = (y1 - y2) as f64;
	let z = (z1 - z2) as f64;
	x * x + y * y + z * z
}

#[cfg(test)]
mod tests {
	use super::*;

	#[test]
	fn reassign_freed_id() {
		let mut db = Database::default();
		let id0 = db.insert([0, 0, 0]);
		let id1 = db.insert([1, 0, 0]);
		assert_eq!(db.len(), 2);
		assert_ne!(id0, id1);
		db.remove(id0);
		assert_eq!(db.len(), 1);
		let id2 = db.insert([0, 1, 0]);
		assert_eq!(db.len(), 2);
		assert_eq!(id0, id2);
	}

	#[test]
	fn nearby() {
		let point0 = [0, 0, 0];
		let point1 = [3037000499, 0, 0];
		let point2 = [3037000499, 3037000499, 0];
		let point3 = [3037000499, 3037000499, 3037000499];
		let mut db = Database::default();
		let id0 = db.insert(point0);
		let id1 = db.insert(point1);
		let id2 = db.insert(point2);
		let id3 = db.insert(point3);
		assert!(db.nearby(point0).contains(&id0));
		assert!(db.nearby(point0).contains(&id1));
		assert!(db.nearby(point1).contains(&id0));
		assert!(db.nearby(point1).contains(&id1));
		assert!(db.nearby(point1).contains(&id2));
		assert!(db.nearby(point2).contains(&id1));
		assert!(db.nearby(point2).contains(&id2));
		assert!(db.nearby(point2).contains(&id3));
		assert!(db.nearby(point3).contains(&id2));
		assert!(db.nearby(point3).contains(&id3));
	}

	#[test]
	fn nearest() {
		let point0 = [0, 0, 0];
		let point1 = [3037000499, 0, 0];
		let point2 = [3037000499, 3037000499, 0];
		let point3 = [3037000499, 3037000499, 3037000499];
		let point4 = [3037000499, 3037000499, 6074000998];
		let mut db = Database::default();
		let id0 = db.insert(point0);
		let id1 = db.insert(point1);
		let id2 = db.insert(point2);
		let id3 = db.insert(point3);
		assert_eq!(db.nearest(point0), id0);
		assert_eq!(db.nearest(point1), id1);
		assert_eq!(db.nearest(point2), id2);
		assert_eq!(db.nearest(point3), id3);
		assert_eq!(db.nearest(point4), id3);
	}
}
