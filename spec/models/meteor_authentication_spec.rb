require 'rails_helper'

describe MongoidDeviseForMeteor::MeteorUserModel do

  let(:meteor_user_attributes) {

    {
        '_id' => "633DYLkePqv2xMbDi",
        "createdAt" => Time.now,
        "emails" => [
            {"address" => Faker::Internet.email,
             "verified" => true}
        ],
        "profile" => {"firstName" => "DemoFirstName",
                      "lastName" => "DemoLastName"
        },
        "services" => {
            "password" => {
                "bcrypt" => "$2a$10$4my6JyO3FxMDr4xm24k2Kev7Jqu0E.8KecXEv8fHhZQMSCHrQCUM."
            },
            "resume" => {
                "loginTokens" => [
                    {
                        "when" => Time.now,
                        "hashedToken" => "fPtV4ud7WzT9nKwgfRb56MwI8GORe3kGc4cO6FfM8xY="
                    }
                ]
            }
        },
        "username" => "demouser"
    }

  }

  describe "Meteor User attribute mapping" do

    it "calls meteor_map_attributes before saving" do
      user = User.new

      expect(user).to receive(:meteor_map_attributes)
      user.save

    end

    before :each do
      @user = create :user
    end

    context 'emails' do

      it 'should be an array' do
        expect(@user.emails).to be_an Array
      end

      describe 'when changing the email' do

        it 'does not verify on new unconfirmed' do
          @user.confirm
          @user.email = "test@test.com"
          result2 = {address: @user.email, verified: false}

          @user.save!
          expect(@user.emails).to include result2
        end

        it 'does verify on confirm' do
          @user.confirm
          @user.email = "test@test.com"
          @user.save!
          result2 = {address: @user.email, verified: true}

          @user.confirm

          expect(@user.emails).to include result2
        end

        it 'does not overwrite old email' do
          result1 = {address: @user.email, verified: true}

          @user.confirm
          @user.email = "test@test.com"
          result2 = {address: @user.email, verified: false}

          @user.save!
          expect(@user.emails).to include result1
          expect(@user.emails).to include result2
        end

      end

      describe 'verified' do

        specify 'on new email should be false' do
          result = {address: @user.email, verified: false}

          expect(@user.emails).to include(result)
        end

        it 'on confirmed email should be true' do
          result = {address: @user.email, verified: true}

          @user.confirm

          expect(@user.emails).to include(result)
        end

      end

    end

    describe 'createdAt' do
      it 'should match created_at' do
        expect(@user.created_at).to eql @user.createdAt
      end
    end

    describe 'profile' do

      it 'has a relation to Profile' do
        expect(@user.profile).to be_a MongoidDeviseForMeteor::MeteorProfile
      end

      describe 'name' do

        it 'writes into name field' do
          name = "John Doe"
          @user.update_attribute(:name, name)
          expect(User.last.profile.name).to eql name
        end

        it 'reads from name field' do
          name = "John Doe"
          @user.update_attribute(:name, name)
          expect(@user.name).to eql @user.profile.name
        end
      end

      describe 'username' do

        it 'writes into name field' do
          username = "John Doe"
          @user.update_attribute(:username, username)
          expect(User.last.profile.username).to eql username
        end

        it 'reads from name field' do
          username = "John Doe"
          @user.update_attribute(:username, username)
          expect(@user.username).to eql @user.profile.username
        end
      end

    end

    describe 'services' do

      # this example is copy pasted from the mongoid_devise_for_meteor documentation
      # http://docs.meteor.com/#/full/meteor_users
      # bcrypt: password decrypted is "asdfasdf"
      let(:valid_services_hash) {
        {"password" => {
            "bcrypt" => "$2a$10$4my6JyO3FxMDr4xm24k2Kev7Jqu0E.8KecXEv8fHhZQMSCHrQCUM."
        },
         "facebook" => {
             "id" => "709050",
             "accessToken" => "S0M3_R34LLY-CMPLX-T0K3N"
         },
         "resume" => {
             "loginTokens" => [
                 {"token" => "4no7eR-c0mpl3x-c0d3-with-numb3r5",
                  "when" => 1234567890}
             ]
         }}
      }

      let(:decrypted_password) {
        'asdfasdf'
      }

      it 'must have a service relation' do
        expect(@user.services).to be_a MongoidDeviseForMeteor::MeteorService
      end

      context 'password' do
        before :each do
          @user.confirm
        end

        let(:valid_password_hash) {
          valid_services_hash[:password]
        }

        context 'changed by devise' do
          it 'writes password on creation' do
            expect(User.last.services.password[:bcrypt]).to eql @user.services.password[:bcrypt]
          end

          it 'writes new password also to session.password' do
            new_password = 'N3W_P455W0RD'

            @user.password = new_password
            @user.password_confirmation = new_password
            @user.save

            expect(User.last.services.password[:bcrypt]).to eql @user.services.password[:bcrypt]
          end

          it 'tries to use the meteors password' do
            password = @user.services.password[:bcrypt]
            true
          end

        end

      end

      context 'facebook' do

        it 'allows multiple provider assignment' do
          @user.services.update_attributes(facebook: valid_services_hash['facebook'])

          expect(User.last.services.facebook[:id]).to eq valid_services_hash['facebook']['id']
          expect(User.last.services.facebook[:id]).to eq valid_services_hash['facebook']['id']
        end

        it 'allows single provider assignment' do
          @user.services.update_attribute(:facebook, valid_services_hash['facebook'])

          expect(User.last.services.facebook[:id]).to eq valid_services_hash['facebook']['id']
          expect(User.last.services.facebook[:accessToken]).to eq valid_services_hash['facebook']['accessToken']
        end

        it 'allows to change provider data' do
          new_facebook_hash = {id: '12345678', accessToken: 'New_Access_token'}

          @user.services.update_attribute(:facebook, valid_services_hash['facebook'])
          expect(User.last.services.facebook[:id]).to eq valid_services_hash['facebook']['id']
          expect(User.last.services.facebook[:accessToken]).to eq valid_services_hash['facebook']['accessToken']

          @user.services.update_attribute(:facebook, new_facebook_hash)

          expect(User.last.services.facebook[:id]).to eq new_facebook_hash[:id]
          expect(User.last.services.facebook[:accessToken]).to eq new_facebook_hash[:accessToken]
        end

      end
    end
  end
end
