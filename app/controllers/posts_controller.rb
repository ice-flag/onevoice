class PostsController < ApplicationController
  before_filter :set_post, only: [:show, :edit, :step1, :step2, :step3,
                                  :update, :destroy]
  before_filter :get_car_data_api, only: [:step2]

  respond_to :html

  def index
    @posts = Post.all
    respond_with(@posts)
  end

  def show
    respond_with(@post)
  end

  def new
    @post = Post.new
    respond_with(@post)
  end

  def edit
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if params[:to_step2]
        @post.save
          format.html { redirect_to step2_post_path(@post) }
          format.json { head :no_content }
      else
        if @post.save
          format.html { redirect_to @post, notice: 'Gefeliciteerd. Je klus is aangemaakt!' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @post.update_attributes(params[:post])
    respond_to do |format|
      if params[:to_step2]
        format.html { redirect_to step2_post_path(@post) }
        format.json { head :no_content }
      elsif params[:to_step3]
        format.html { redirect_to step3_post_path(@post) }
        format.json { head :no_content }
      else
        format.html { redirect_to @post, notice: 'Gefeliciteerd. Je klus is geupdated!' }
        format.json { render json: @post, status: :created, location: @post }
      end
    end
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def get_car_data_api
      require 'open-uri'
      require 'nokogiri'

      @result = Nokogiri.XML(open("https://api.datamarket.azure.com/opendata.rdw/VRTG.Open.Data/v1/KENT_VRTG_O_DAT?$filter=Kenteken%20eq%20%27#{@post.license_plate.to_s.gsub("-","").gsub(" ","").upcase}%27").read)
      model = @result.to_s.match(/Handelsbenaming.*\:Handelsbenaming/)
      make = @result.to_s.match(/Merk.*\:Merk/)
      @lp_make = make.to_s.gsub("Merk>","").gsub("</d:Merk","").gsub("AUTO UNION","AUDI").gsub("MERCEDES-BENZ","MERCEDES").gsub("MICRO COMPACT CAR SMART","SMART").gsub("MICRO COMPACT CAR","SMART").gsub(" ", "%20")
      ccm = @result.to_s.match(/Cilinderinhoud.*\:Cilinderinhoud/)
      @lp_cylinder = ccm.to_s.gsub("Cilinderinhoud m:type=","").gsub('"',"").gsub("Edm.Int32>","").gsub("</d:Cilinderinhoud","")
      year = @result.to_s.match(/Datumeerstetoelating.*\:Datumeerstetoelating/)
      formatted_year = year.to_s.gsub("Datumeerstetoelating m:type=","").gsub('"',"").gsub("Edm.DateTime>","").gsub("</d:Datumeerstetoelating","")
      seats = @result.to_s.match(/Aantalzitplaatsen.*\:Aantalzitplaatsen/)
      @lp_seats = seats.to_s.gsub("Aantalzitplaatsen m:type=","").gsub('"',"").gsub("Edm.Int16>","").gsub("</d:Aantalzitplaatsen","")
      lp_car_category = @result.to_s.match(/Voertuigsoort.*\:Voertuigsoort/)
      @lp_car_category = lp_car_category.to_s.gsub("Voertuigsoort>","").gsub('"',"").gsub("</d:Voertuigsoort","")
      lp_model_type = @result.to_s.match(/Inrichting.*\:Inrichting/)
      @lp_model_type = lp_model_type.to_s.gsub("Inrichting>","").gsub('"',"").gsub("</d:Inrichting","")
      lp_fuel = @result.to_s.match(/Hoofdbrandstof.*\:Hoofdbrandstof/)
      @lp_fuel = lp_fuel.to_s.gsub("Hoofdbrandstof>","").gsub('"',"").gsub("</d:Hoofdbrandstof","")
      lp_apk = @result.to_s.match(/VervaldatumAPK.*\:VervaldatumAPK/)
      temp_apk = lp_apk.to_s.gsub("VervaldatumAPK m:type=","").gsub('"',"").gsub("Edm.DateTime>","").gsub("</d:VervaldatumAPK","")


      if model.to_s.match(";")
        ar1 = model.to_s.split(";")
        ar2 = ar1[0].to_s.split(" ")
        
        if ar1[0].to_s.titleize.match("Alfa Romeo")
          @model = ar2[2].to_s
        elsif ar2[0].to_s.titleize.match("#{@lp_make.to_s.titleize}")
          @model = ar2[1].to_s
        else
          if ar2[1].present?
            ar3 = ar2[0].to_s + " " + ar2[1].to_s
            @model = ar3.to_s.gsub(" ","").gsub(" ","")
          else
            @model = ar2[0].to_s
          end
        end
      else
        ar1 = model.to_s.split(" ")
        if model.to_s.titleize.match("Alfa Romeo")
          @model = ar1[2].to_s
        elsif @lp_make.to_s.titleize.match("Auto Union")
          @model = ar1[1].to_s
        elsif ar1[1].present?
          if ar1[0].to_s.titleize.match("#{@lp_make.to_s.titleize}")
            @model = ar1[1]
          else
            @model = ar1[0]
          end
        else
          @model = ar1[0]
        end
      end

      @lp_model = @model.to_s.gsub("Handelsbenaming>","").gsub("</d:Handelsbenaming","").gsub("-","").gsub("CARAVAN","").gsub("1J","GOLF4").gsub("ASTRAGCC","ASTRAG").gsub("3ERREIHE","3").gsub("8DAUDI","A4").gsub("8GAUDI","80").gsub("1ER","1").gsub("316I","3").gsub("318CI","3").gsub("3ER","3").gsub("318I","3").gsub("318","3").gsub("320","3").gsub("320I","3").gsub("328","3").gsub("518I","5").gsub("7ERREIHE","7").gsub("ZREIHE","Z").gsub("S0CDZF","SAXO").gsub("ACCORDSEDAN","ACCORD").gsub("CIVIC3DR","CIVIC").gsub("CIVIC3","CIVIC").gsub("CIVIC5DR","CIVIC").gsub("CIVIC5","CIVIC").gsub("ATOSPRIME","ATOS").gsub("35S","DAILY").gsub("50C","DAILY").gsub("Y)","Y").gsub("638/1","638").gsub("C180","W202").gsub("C200","W202").gsub("C220","W202").gsub("C230","W202").gsub("C280","W202").gsub("202078","W202").gsub("202080","W202").gsub("311CDI","SPRINTER").gsub("903.6","SPRINTER").gsub("904.6","SPRINTER").gsub("VIANO,CDI","VIANO").gsub("638.094","638").gsub("SMART","").gsub("PAJEROPININ","PAJERO").gsub("VECTRAB","VECTRA").gsub("VECTRASTATION","VECTRA").gsub("ASTRAGCOUPE","ASTRAG").gsub("S93","TIGRA").gsub("ZAFIRAA","ZAFIRA").gsub("TIGRAA","TIGRA").gsub("COMBOBVAN","COMBO").gsub("MERIVAA","MERIVA").gsub("ASTRASTATION","ASTRA").gsub("VECTRACCC","VECTRAC").gsub("ASTRAFCC","ASTRAF").gsub("T98MONOCAB","ASTRAG")

      if formatted_year.present?
        ar21 = formatted_year.to_s.split("T")
        ar22 = ar21[0].to_s.split("-")
        @lp_year = ar22[1].to_s + "-" + ar22[0].to_s
      else
        @lp_year = 0
      end

      if temp_apk.present?
        ar21 = temp_apk.to_s.split("T")
        ar22 = ar21[0].to_s.split("-")
        @lp_apk = ar22[2].to_s + "-" + ar22[1].to_s + "-" + ar22[0].to_s
      else
        @lp_apk = 0
      end
    end
end
