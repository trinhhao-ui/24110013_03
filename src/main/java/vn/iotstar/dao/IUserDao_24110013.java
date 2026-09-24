package vn.iotstar.dao;

import vn.iotstar.entity.User_24110013;
import java.util.List;

public interface IUserDao_24110013 {
    void insert(User_24110013 user);
    void update(User_24110013 user);
    void delete(String username);
    User_24110013 findById(String username);
    User_24110013 findByEmail(String email);
    List<User_24110013> findAll();
    User_24110013 checkLogin(String username, String password);
}
