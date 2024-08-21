
#include "transform.h"

Mat4 Transform::local_to_parent() const {
	return Mat4::translate(translation) * rotation.to_mat() * Mat4::scale(scale);
}

Mat4 Transform::parent_to_local() const {
	return Mat4::scale(1.0f / scale) * rotation.inverse().to_mat() * Mat4::translate(-translation);
}

Mat4 Transform::local_to_world() const {
	// A1T1: local_to_world
	//don't use Mat4::inverse() in your code.
	Mat4 local_to_parent_matrix = local_to_parent();

	// Check if the transform has a parent
	if (std::shared_ptr<Transform> parent_ = parent.lock()) {
		// Recursively get the parent's local_to_world transformation
		Mat4 parent_to_world_matrix = parent_->local_to_world();
		// Combine the parent's transformation with the local transformation
		return parent_to_world_matrix * local_to_parent_matrix;
	}
	else {
		// If no parent, the local_to_world is just the local_to_parent matrix
		return local_to_parent_matrix;
	}
}

Mat4 Transform::world_to_local() const {
	// A1T1: world_to_local
	//don't use Mat4::inverse() in your code.

	Mat4 local_to_parent_matrix = local_to_parent();

	// Check if the transform has a parent
	if (std::shared_ptr<Transform> parent_ = parent.lock()) {
		// Recursively get the parent's world_to_local transformation
		Mat4 parent_to_local_matrix = parent_->world_to_local();
		// Combine the inverse of the local transformation with the parent's inverse transformation
		return local_to_parent_matrix.inverse() * parent_to_local_matrix;
	}
	else {
		// If no parent, the world_to_local is just the inverse of the local_to_parent matrix
		return local_to_parent_matrix.inverse();
	}
}

bool operator!=(const Transform& a, const Transform& b) {
	return a.parent.lock() != b.parent.lock() || a.translation != b.translation ||
	       a.rotation != b.rotation || a.scale != b.scale;
}
