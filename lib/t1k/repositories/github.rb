require 'github_api'

module T1k
  module Repositories
    class Github

      cattr_accessor :oauth_token
      @@oauth_token = ""

      cattr_accessor :user
      @@user = ""

      cattr_accessor :repo
      @@repo = ""

      cattr_accessor :messages
      @@messages = []
      cattr_accessor :errors
      @@errors = []

      Issue = Struct.new(:code, :link)

      def self.setup &block
        yield(self) if block_given?
      end

      def self.valid_keys?
        begin
          me = ::Github.new(oauth_token: self.oauth_token).users.get
          @@messages << "Wecolme #{me.name} - Github"
          return true
        rescue Exception => e
          @@errors << e.message
          return false
        end
      end

      def self.create_issue title
        begin
          puts 'Creating issue'
          github_auth = ::Github.new(oauth_token: self.oauth_token)
          issue = github_auth.issues.create(user: self.user, repo: self.repo, title: title)
          issue
        rescue
          raise 'Issue not created'
        end
      end

      def self.get_issue issue_number
        begin
          puts 'Recovering existent issue'
          github_auth = ::Github.new(oauth_token: self.oauth_token)
          issue = github_auth.issues.get user: self.user, repo: self.repo, number: issue_number
          issue
        rescue
          raise 'Issue not recovered'
        end
      end

      def self.get_issue_number html_url
        code = html_url[html_url.rindex('/')+1..html_url.size]
        Issue.new(code, "Link to code: [#{code}](#{html_url})")
      end
    end
  end
end