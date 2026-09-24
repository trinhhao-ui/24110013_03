package vn.iotstar.service;

import vn.iotstar.entity.User_24110013;
import java.util.List;

public interface IUserService_24110013 {
    void register(User_24110013 user);
    void update(User_24110013 user);
    void delete(String username);
    User_24110013 findById(String username);
    User_24110013 findByEmail(String email);
    List<User_24110013> findAll();
    User_24110013 login(String username, String password);
    boolean checkExistUsername(String username);
    boolean checkExistEmail(String email);
    boolean activateUser(String username);
}
