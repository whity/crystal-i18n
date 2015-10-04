require "./spec_helper"

describe I18n do
    it "create yaml backend" do
        yaml_backend.should(be_a(I18n::Backend::Base))
    end

    it "create i18n object with yaml backend" do
        i18n_yaml_backend.should(be_a(I18n::I18n))
    end

    it "translate" do
        obj = i18n_yaml_backend
        obj.translate("hello").should(eq("olá"))
    end

    it "pluralization translate 1" do
        obj = i18n_yaml_backend
        obj.translate("new_message", count: 1).should(eq("tem uma nova mensagem"))
    end

    it "pluralization translate 2" do
        obj = i18n_yaml_backend
        obj.translate("new_message", count: 2).should(eq("tem 2 novas mensagens"))
    end

    it "format number" do
        obj = i18n_yaml_backend
        obj.number(1234.to_s).should(eq("1.234"))
    end

    it "format number with decimals" do
        obj = i18n_yaml_backend
        obj.number(123.123.to_s).should(eq("123,123"))
    end

    it "format number to currency" do
        obj = i18n_yaml_backend
        obj.currency(123.123.to_s).should(eq("€123,123"))
    end

    it "time default format" do
        time = Time.now
        obj  = i18n_yaml_backend
        obj.time(time).should(eq(time.to_s("%H:%M:%S")))
    end

    it "date default format" do
        time = Time.now
        obj  = i18n_yaml_backend
        obj.date(time).should(eq(time.to_s("%Y-%m-%d")))
    end

    it "date long format" do
        time = Time.now
        obj  = i18n_yaml_backend
        obj.date(time, locale: "en", format: "long").should(eq(time.to_s("%A, %d of %B %Y")))
    end
end
