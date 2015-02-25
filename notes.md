$ rails new workout_log

# generate workout model
$ rails g model workout date:datetime workout:string mood:string length:string
$ rake db:migrate

$ git init
$ git status
$ git add .
$ git commit -am "Initial Commit & Workout Model"
$ rails g controller workouts

# add resources for routes
#/config/routes.rb
resources :workouts
root 'workouts#index'

#/app/controllers/workouts_controller.rb
def index
end

# git commit

#/Gemfile
gem 'haml', '~> 4.0.5'
gem 'simple_form', '~> 3.0.2'
gem 'bootstrap-sass', '~>3.2.0.2'

$bundle install
#restart server

#rename app/assets/stylesheets/application.css to application.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

#app/assets/javascripts/application.js
//= require bootstrap-sprockets

#install simple_form
$ rails generate simple_form:install --bootstrap

#Create views for workouts/index
#app/views/workouts/index.html.haml
%h1 This is the workout#index placeholder

#app/controllers/workouts_controller.rb
def index
end

def show
end

def new
  @workout = Workout.new
end

def create
  @workout = Workout.new(workout_params)
  if @workout.save
    redirect_to @workout
  else
    render 'new'
end

def edit
end

def update
end

def destroy
end

private

def workout_params
  params.require(:workout).permit(:date, :workout, :mood, :length)
end

def find_workout
end

#app/views/workouts/new.html.haml
%h1 New Workout

= render 'form'

= link_to "Cancel", root_path



#app/view/workouts/_form.html.haml __
= simple_form_for(@workout, html: { class: 'form-horizontal'}) do |f|
  = f.input :date, label: "Date"
  = f.input :workout, label: "Workout Area", input_html: { class: "form-control"}
  = f.input :mood, label: "How're you feeling?", input_html: { class: "form-control"}
  = f.input :length, label: "How long was the workout?", input_html: { class: "form-control"}
  %br/
  = f.button :submit

#error on show page, must create app/views/workouts/show.html.haml
#workout
  %p= @workout.date
  %p= @workout.workout
  %p= @workout.mood
  %p= @workout.length

#have to set find_workout in app/controllers/workouts_controller
def find_workout
  @workout = Workout.find(params[:id])
end

#set before_action :find_workout in workouts_controller
before_action :find_workout, only: [:show, :edit, :update, :destroy]

#change app/views/workouts/index.html.haml to show all workouts
- @workouts.each do |workout|
  %h2= link_to workout.date, workout
  %h3= workout.workout

#set index to show @workouts in app/controllers/workout_controller.rb, sort by created by descending
def index
  @workouts = Workout.all.order("created_at DESC")
end

#change update in app/controllers/workout_controller.rb
def update
  if @workout.update(workout_params)
    redirect_to @workout
  else
    render 'edit'
  end
end

#update app/views/workouts/show.html.haml to show back/edit
= link_to "Back", root_path
|
= link_to "Edit", edit_workout_path(@workout)

#create app/views/workouts/edit.html.haml
%h1 Edit Workout

= render 'form'

= link_to "Cancel", root_path

#destroy in app/controllers/workouts_controller.rb
def destroy
  @workout.destroy
  redirect_to root_path
end

#add to app/views/workouts/show.html.haml
= link_to "Delete", workout_path(@workout), method: :delete, data: { confirm: "Are you sure?" }

#change app/views/layouts/application.html.erb to .application.html.haml
!!!
%html
%head
	%title Workout Log Application
	= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
	= javascript_include_tag 'application', 'data-turbolinks-track' => true
	= csrf_meta_tags
%body
	%nav.navbar.navbar-default
		.container
			.navbar-header
				= link_to "Workout Log", root_path, class: "navbar-brand"
			.nav.navbar-nav.navbar-right
				= link_to "New Workout", new_workout_path, class: "nav navbar-link"

	.container
		= yield

#create new model to define exercises and keep references on workouts
$ rails g model exercise name:string set:integer reps:integer workout:references
$ rake db:migrate

#add association in workout.rb
has_many :exercises

#add nested routes in config/routes.rb
resources :workouts do
  resources :exercises
end

#check out new routes
$rake routes

#generate controller for exercises
$ rails g controller exercises

#populate create action in app/controllers/exercises_controller
def create
  @workout = Workout.find(params[:workout_id])
  @exercise = @workout.exercises.create(params[:workout.permit(:name, :sets, :reps)])

  redirect_to workout_path(@workout)
end

#create views for exercises
#create app/views/exercises/_form.html.html __
= simple_form_for ([@workout, @workout.exercises.build]) do |f|
  = f.input :name, input_html: { class: "form-control" }
  = f.input :sets, input_html: { class: "form-control" }
  = f.input :reps, input_html: { class: "form-control" }
  %br/
  =f.button :submit

#create app/views/exercises/_exercise.html.html __
%p= exercise.name
%p= exercise.sets
%p= exercise.reps

#if you delete a workout, the exercises will also be deleted, edit in app/models/workout.rb
has_many :exercises, dependent: :destroy

#update index to show time/date in better format in app/views/workouts/index
%h2= link_to workout.date.strftime("%A, %B %d"), workout

#styling in app/assets/stylesheets/application.css.scss
html {
	height: 100%;
}

body {
	background: -webkit-linear-gradient(90deg, #616161 10%, #9bc5c3 90%); /* Chrome 10+, Saf5.1+ */
  background:    -moz-linear-gradient(90deg, #616161 10%, #9bc5c3 90%); /* FF3.6+ */
  background:     -ms-linear-gradient(90deg, #616161 10%, #9bc5c3 90%); /* IE10 */
  background:      -o-linear-gradient(90deg, #616161 10%, #9bc5c3 90%); /* Opera 11.10+ */
  background:         linear-gradient(90deg, #616161 10%, #9bc5c3 90%); /* W3C */
}

.navbar-default {
	background: rgba(250, 250, 250, 0.5);
	-webkit-box-shadow: 0 1px 1px 0 rgba(0,0,0,.2);
	box-shadow: 0 1px 1px 0 rgba(0,0,0,.2);
	border: none;
	border-radius: 0;
	.navbar-header {
		.navbar-brand {
			color: white;
			font-size: 20px;
			text-transform: uppercase;
			font-weight: 700;
			letter-spacing: -1px;
		}
	}
	.navbar-link {
		line-height: 3.5;
		color: rgb(48, 181, 199);
	}
}

#index_workouts {
	h2 {
		margin-bottom: 0;
		font-weight: 100;
		a {
			color: white;
		}
	}
	h3 {
		margin: 0;
		font-size: 18px;
		span {
			color: rgb(48, 181, 199);
		}
	}
}
