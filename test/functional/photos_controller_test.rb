require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @photo = photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, photo: { date_uploaded: @photo.date_uploaded, description: @photo.description, last_view: @photo.last_view, num_comments: @photo.num_comments, private: @photo.private, rating: @photo.rating, title: @photo.title, view_count: @photo.view_count }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should show photo" do
    get :show, id: @photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @photo
    assert_response :success
  end

  test "should update photo" do
    put :update, id: @photo, photo: { date_uploaded: @photo.date_uploaded, description: @photo.description, last_view: @photo.last_view, num_comments: @photo.num_comments, private: @photo.private, rating: @photo.rating, title: @photo.title, view_count: @photo.view_count }
    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete :destroy, id: @photo
    end

    assert_redirected_to photos_path
  end
end
