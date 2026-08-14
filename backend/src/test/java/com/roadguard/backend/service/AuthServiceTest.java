package com.roadguard.backend.service;

import com.roadguard.backend.dto.AuthDtos;
import com.roadguard.backend.entity.User;
import com.roadguard.backend.repository.UserRepository;
import com.roadguard.backend.security.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AuthServiceTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @BeforeEach
    void cleanDb() {
        userRepository.deleteAll();
    }

    @Test
    void register_createsUserAndReturnsTokens() {
        AuthDtos.RegisterRequest request = AuthDtos.RegisterRequest.builder()
                .name("Test User")
                .email("test@example.com")
                .password("password123")
                .build();

        AuthDtos.AuthResponse response = authService.register(request);

        assertThat(response.getAccessToken()).isNotBlank();
        assertThat(response.getRefreshToken()).isNotBlank();
        assertThat(response.getUser().getEmail()).isEqualTo("test@example.com");
        assertThat(response.getUser().getName()).isEqualTo("Test User");
        assertThat(response.getUser().getRole()).isEqualTo("CITIZEN");
        assertThat(response.getUser().getTrustScore()).isEqualTo(50);
        assertThat(response.getUser().isTrusted()).isFalse();

        User saved = userRepository.findByEmail("test@example.com").orElseThrow();
        assertThat(passwordEncoder.matches("password123", saved.getPassword())).isTrue();
    }

    @Test
    void register_duplicateEmail_throwsConflict() {
        userRepository.save(User.builder()
                .name("Existing")
                .email("test@example.com")
                .password(passwordEncoder.encode("password123"))
                .build());

        AuthDtos.RegisterRequest request = AuthDtos.RegisterRequest.builder()
                .name("New User")
                .email("test@example.com")
                .password("password123")
                .build();

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(com.roadguard.backend.exception.ApiException.class)
                .hasMessageContaining("EMAIL_EXISTS");
    }

    @Test
    void login_validCredentials_returnsTokens() {
        userRepository.save(User.builder()
                .name("Test User")
                .email("test@example.com")
                .password(passwordEncoder.encode("password123"))
                .build());

        AuthDtos.LoginRequest request = AuthDtos.LoginRequest.builder()
                .email("test@example.com")
                .password("password123")
                .build();

        AuthDtos.AuthResponse response = authService.login(request);

        assertThat(response.getAccessToken()).isNotBlank();
        assertThat(response.getRefreshToken()).isNotBlank();
    }

    @Test
    void login_invalidPassword_throwsUnauthorized() {
        userRepository.save(User.builder()
                .name("Test User")
                .email("test@example.com")
                .password(passwordEncoder.encode("password123"))
                .build());

        AuthDtos.LoginRequest request = AuthDtos.LoginRequest.builder()
                .email("test@example.com")
                .password("wrongpassword")
                .build();

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(org.springframework.security.authentication.BadCredentialsException.class);
    }

    @Test
    void refreshToken_validToken_returnsNewAccessToken() {
        User user = userRepository.save(User.builder()
                .name("Test User")
                .email("test@example.com")
                .password(passwordEncoder.encode("password123"))
                .build());

        String refreshToken = jwtService.generateRefreshToken(user);

        AuthDtos.RefreshTokenRequest request = AuthDtos.RefreshTokenRequest.builder()
                .refreshToken(refreshToken)
                .build();

        AuthDtos.AuthResponse response = authService.refreshToken(request);

        assertThat(response.getAccessToken()).isNotBlank();
        assertThat(response.getRefreshToken()).isEqualTo(refreshToken);
    }
}