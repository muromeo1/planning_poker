# Its a base interactor, that can be used in all interactor types.
# Is used to: [ validate private methods, require params ]
#
# to use:
#
# include Interactor
# include BaseInteractor <-- add this include line bellow 'interactor include'
#
# --------------------------------------------
# to validate params passed on context:
#
# requires :user_id, :company
#
# def call
#   ...
# end
#
#---------------------------------------------
# to validate a private method: (it will check if is present?)
#
# requires :user_id, :company
# validates :my_private_method
#
# def call
#   ...
# end
#
# --------------------------------------------

module BaseInteractor
  def self.included(klass)
    klass.extend ClassMethods
  end

  def attribute_exists?(method_name)
    context.public_send(method_name).present?
  end

  def method_valid?(method_name)
    send(method_name)&.present? || false
  end

  module ClassMethods
    def requires(*args)
      before do
        args.each do |arg|
          context.fail!(error: ":#{arg} cant be nil") unless attribute_exists?(arg)
        end
      end

      delegate(*args, to: :context)
    end

    def validate(*args, i18n_path: '')
      before do
        args.each do |arg|
          next if method_valid?(arg)

          translation = I18n.t(i18n_path + ".#{arg}", default: '')
          message     = translation.present? ? translation : "##{arg} returned false"

          context.fail!(error: message)
        end
      end
    end
  end
end
