package vn.iotstar.service;

import vn.iotstar.dao.IUserDao_24110013;
import vn.iotstar.dao.UserDao_24110013;
import vn.iotstar.entity.User_24110013;
import java.util.List;

public class UserService_24110013 implements IUserService_24110013 {
    private IUserDao_24110013 userDao = new UserDao_24110013();

    @Override
    public void register(User_24110013 user) {
        userDao.insert(user);
    }

    @Override
    public void update(User_24110013 user) {
        userDao.update(user);
    }

    @Override
    public void delete(String username) {
        userDao.delete(username);
    }

    @Override
    public User_24110013 findById(String username) {
        return userDao.findById(username);
    }

    @Override
    public User_24110013 findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public List<User_24110013> findAll() {
        return userDao.findAll();
    }

    @Override
    public User_24110013 login(String username, String password) {
        User_24110013 user = userDao.checkLogin(username, password);
        if (user != null && user.getActive()) {
            return user;
        }
        return null;
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.findById(username) != null;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.findByEmail(email) != null;
    }

    @Override
    public boolean activateUser(String username) {
        User_24110013 user = userDao.findById(username);
        if (user != null) {
            user.setActive(true);
            userDao.update(user);
            return true;
        }
        return false;
    }
}
