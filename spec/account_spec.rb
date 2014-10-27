# encoding: utf-8
require 'spec_helper'

describe SEPA::Account do
  describe :new do
    it 'should not accept unknown keys' do
      expect {
        SEPA::Account.new foo: 'bar'
      }.to raise_error(NoMethodError)
    end
  end

  describe :name do
    it 'should accept valid value' do
      expect(SEPA::Account).to accept('Gläubiger GmbH', 'Zahlemann & Söhne GbR', 'X' * 70, for: :name)
    end

    it 'should not accept invalid value' do
      expect(SEPA::Account).not_to accept(nil, '', 'X' * 71, for: :name)
    end
  end

  describe :iban do
    it 'should accept valid value' do
      expect(SEPA::Account).to accept('DE21500500009876543210', 'PL61109010140000071219812874', for: :iban)
    end

    it 'should not accept invalid value' do
      expect(SEPA::Account).not_to accept(nil, '', 'invalid', for: :iban)
    end

    context 'with non-canonical value' do
      it 'should accept valid value' do
        expect(SEPA::Account).to accept('de21 5005 0000 9876 5432 10', 'Pl61 1090 1014 0000 0712 1981 2874', for: :iban)
      end

      it 'should canonicalize value' do
        expect(SEPA::Account.new(iban: 'de21 5005 0000 9876 5432 10').iban).to eq('DE21500500009876543210')
      end
    end
  end

  describe :bic do
    it 'should accept valid value' do
      expect(SEPA::Account).to accept('DEUTDEFF', 'DEUTDEFF500', 'SPUEDE2UXXX', for: :bic)
    end

    it 'should not accept invalid value' do
      expect(SEPA::Account).not_to accept('', 'invalid', for: :bic)
    end
  end
end
