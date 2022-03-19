# ./deploy.sh hugo manually
# navigate into the build output directory
hugo
cd public

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git branch -m main
git add .
# git config --local user.name bacnotes
# git config --local user.email bacnotes.com
git commit -m 'deploy'

# if you are deploying to https://<USERNAME>.github.io
# git push -f https://github.com/<USERNAME>/<USERNAME>.GitHub.io.git main
# blog: git remote add origin git@gh.b:bacnotes/hugo.git
# git push 
# git remote remove origin
git remote add origin git@gh.b:bacnotes/bacnotes.github.io.git

git push -f --set-upstream origin main
cd -