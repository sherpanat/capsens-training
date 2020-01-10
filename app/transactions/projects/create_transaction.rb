module Projects
  class CreateTransaction < ::BaseTransaction
    step :create_project
    step :create_mangopay_legal_user
    step :create_mangopay_project_wallet

    def create_project(attributes)
      @project = Project.new(attributes)
      if @project.save
        Success(@project)
      else
        Failure(error: @project.errors.full_messages.join(' | '), project: @project)
      end
    end

    def create_mangopay_legal_user
      mangopay_legal_user = MangoPay::LegalUser.create(
        Name: @project.name,
        LegalPersonType: "BUSINESS",
        LegalRepresentativeFirstName: @project.owner_first_name,
        LegalRepresentativeLastName: @project.owner_last_name,
        LegalRepresentativeBirthday: @project.owner_birthdate.to_time.to_i,
        LegalRepresentativeNationality: 'FR',
        LegalRepresentativeCountryOfResidence: 'FR',
        Email: @project.email
      )
      @project.update!(mangopay_id: mangopay_legal_user['Id'])
      Success(project: @project, mangopay_legal_user: mangopay_legal_user)
    end

    def create_mangopay_project_wallet
      mangopay_wallet = MangoPay::Wallet.create(
        Owners: [@project.mangopay_id],
        Description: "main wallet of the project",
        Currency: "EUR"
      )
      @project.update!(wallet_id: mangopay_wallet['Id'])
      Success(project: @project, mangopay_wallet: mangopay_wallet)
    end
  end
end
