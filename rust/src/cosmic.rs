use fixed::traits::{Fixed, FromFixed, ToFixed};
use fixed::types::I96F32 as Number;
use std::ops;

#[derive(Copy, Clone, Default)]
pub struct Cosmic3 {
	x: Number,
	y: Number,
	z: Number,
}

impl Cosmic3 {
	pub fn into_f32x6(mut self) -> [f32; 6] {
		[
			self.x.skim_float(),
			self.y.skim_float(),
			self.z.skim_float(),
			self.x.skim_float(),
			self.y.skim_float(),
			self.z.skim_float(),
		]
	}
}

impl ops::Neg for Cosmic3 {
	type Output = Self;
	fn neg(self) -> Self::Output {
		Cosmic3 {
			x: -self.x,
			y: -self.y,
			z: -self.z,
		}
	}
}

impl ops::AddAssign<Self> for Cosmic3 {
	fn add_assign(&mut self, rhs: Self) {
		self.x += rhs.x;
		self.y += rhs.y;
		self.z += rhs.z;
	}
}

impl ops::MulAssign<Self> for Cosmic3 {
	fn mul_assign(&mut self, rhs: Self) {
		self.x *= rhs.x;
		self.y *= rhs.y;
		self.z *= rhs.z;
	}
}

impl ops::SubAssign<Self> for Cosmic3 {
	fn sub_assign(&mut self, rhs: Self) {
		self.x -= rhs.x;
		self.y -= rhs.y;
		self.z -= rhs.z;
	}
}

impl ops::Add<Self> for Cosmic3 {
	type Output = Self;
	fn add(mut self, rhs: Self) -> Self {
		self += rhs;
		self
	}
}

impl ops::Sub<Self> for Cosmic3 {
	type Output = Self;
	fn sub(mut self, rhs: Self) -> Self {
		self -= rhs;
		self
	}
}

impl<T> ops::AddAssign<[T; 3]> for Cosmic3
where
	T: ToFixed + Copy,
{
	fn add_assign(&mut self, rhs: [T; 3]) {
		self.x += Number::from_num(rhs[0]);
		self.y += Number::from_num(rhs[1]);
		self.z += Number::from_num(rhs[2]);
	}
}

impl<T> ops::Add<[T; 3]> for Cosmic3
where
	T: ToFixed + Copy,
{
	type Output = Self;
	fn add(mut self, rhs: [T; 3]) -> Self {
		self.x += Number::from_num(rhs[0]);
		self.y += Number::from_num(rhs[1]);
		self.z += Number::from_num(rhs[2]);
		self
	}
}

pub trait FromFixed3<T> {
	fn to_num(&self) -> [T; 3];
}

impl<T> FromFixed3<T> for Cosmic3
where
	T: FromFixed,
{
	fn to_num(&self) -> [T; 3] {
		[self.x.to_num(), self.y.to_num(), self.z.to_num()]
	}
}

pub trait RootBeerFloat {
	fn skim_float(&mut self) -> f32;
}

impl<T> RootBeerFloat for T
where
	T: Fixed,
{
	fn skim_float(&mut self) -> f32 {
		let value: f32 = self.to_num();
		*self -= T::from_num(value);
		value
	}
}
